class Project < ActiveRecord::Base
  belongs_to :user
  has_many :notes

  def self.recent
    order('created_at DESC')
  end

  def reflect
    notewords = []
    frequencies = Hash.new(0)

    self.notes.each do |note|
      # notewords.concat(note.scrubbed_notes['words'])
      notewords.concat(note.scrubbed_notes)
    end

    notewords.each { |noteword| frequencies[noteword] += 1 }

    frequencies = frequencies.sort_by {|k,v| v}
    frequencies.reverse!

    reflections = []
    unless frequencies.blank?
      # reflections.push('hi')
      10.times do |w|
        word = frequencies[w][0]
        value = frequencies[w][1]
        reflections.push({:word => word, :value => value})
      end
    end

    reflections

    # Example Data Format For Visualization
    # # [ {:word => "lets", :value => 10},
    #   {:word => "see", :value => 7},
    #   {:word => "if", :value => 3},
    #   {:word => "this", :value => 14},
    #   {:word => "works", :value => 1} ]
  end

  def tfidf_matrix(terms)
    # Initialize data structures and term list
    # terms = self.term_list
    tfidf = Array.new(self.notes.count) { Array.new(terms.length, 0) }

    # Assemble frequency matrix
    self.notes.order(created_at: :desc).each_with_index do |note,index|
      note.scrubbed_notes.each do |word|
        term_index = terms.index(word)
        tfidf[index][term_index] += 1
      end
    end

    # Determine idf
    idf = Array.new(terms.length, 0)
    tfidf.map do |note|
      note.each_with_index do |tf,index|
        if tf > 0
          idf[index] += 1
        end
      end
    end

    # Adjust tf values to normalize document length
    # Using augmented weighting scheme
    tfidf.map do |note|
      tf_max = note.max
      note.map! do |tf|
        tf = 0.5 + ((0.5 * tf)/tf_max)
      end
    end

    # Incorporate idf
    tfidf.map do |note|
      note.each_with_index do |tf,index|
        note[index] = tf * Math.log(idf.length/idf[index])
      end
    end

    # Normalize all vectors to unit length
    tfidf.map do |note|
      euclength_raw = 0
      note.map { |tf| euclength_raw += tf**2 }
      euclength = Math.sqrt(euclength_raw)
      note.map! { |tf| tf = tf/euclength }
    end

    # Return tf-idf matrix representing all notes in vector space
    tfidf

  end

  # Assemble full list of terms
  def term_list
    terms = Array.new

    self.notes.each do |note|
      note.scrubbed_notes.each do |word|
        term_index = terms.index(word)
        if term_index.nil?
          terms.push(word)
        end
      end
    end
    terms
  end

  # Kmeans clustering
  def kmeans(tfidf)
    # Number of seeds
    k = 5

    # Stop conditions
    i_max = 30

    # Assemble vector space model
    # tfidf = self.tfidf_matrix

    # Random selection of seeds
    seeds = Array.new(k)
    seednums = Array.new(k)
    k.times do |seed|
      protoseed = nil
      while seednums.include?(protoseed)
        protoseed = rand((self.notes.count - 1))
      end
      seednums[seed] = protoseed
      seeds[seed] = tfidf[protoseed]
    end

    clusters = Array.new(k) { Array.new() }
    # Cluster
    i = 0
    clusterflag = 1
    while (i < i_max && clusterflag == 1)
      clusterflag = 0
      # Clear clusters
      clusters = Array.new(k) { Array.new() }

      # Assign each note to a cluster
      tfidf.each_with_index do |note,nindex|
        min_index = 0
        min_dist = Float::INFINITY

        seeds.each_with_index do |seed, sindex|
          eucdist = 0
          note.each_with_index do |ele, eindex|
            eucdist = eucdist + ((seed[eindex] - ele)**2)
          end
          if eucdist < min_dist
            min_dist = eucdist
            min_index = sindex
          end
        end

        clusters[min_index].push(nindex)
      end

      # Recalculate seeds
      clusters.each_with_index do |cluster,cindex|
        newseed = Array.new(tfidf[0].length, 0)
        cluster.each do |note|
          newseed.each_with_index do |ele, index|
            newseed[index] = ele + tfidf[note][index]
          end
        end
        newseed.map! { |ele| ele = ele/(cluster.length) }
        if seeds[cindex] != newseed
          clusterflag = 1
        end
        seeds[cindex] = newseed
      end

      i += 1
    end

    # Return results
    [seeds,clusters]
  end

  def hac(tfidf)
    # Set number of clusters (simplest cutoff method)
    k = 7

    # Initialize arrays
    c = Array.new(tfidf.length) { Array.new(tfidf.length) { Array.new(2, 0) } }
    p = c
    j = Array.new(tfidf.length, 0)
    a = Array.new()
    clusters = Array.new(tfidf.length) { Array.new() }

    # Initial similarity matrix and cluster activity array
    tfidf.each_with_index do |n, n_index|
      tfidf.each_with_index do |i, i_index|
        c[n_index][i_index][0] = dotproduct(n, i)
        c[n_index][i_index][1] = i_index
      end
      j[n_index] = 1
      clusters[n_index].push(n_index)
    end

    # Sort similarity matrix into priority queue
    c.each_with_index do |c_n, index|
      p[index] = c_n.sort { |x,y| y[0] <=> x[0] }
    end

    # Remove self similarities from priority queue
    p.each_with_index do |p_n, index|
      p_n.delete_if { |item| item[1] == index }
    end

    # Main clustering loop
    (j.length - 1 - k).times do |count|
      #Find the clusters to merge
      k_1 = 0
      k_2 = 0
      max_sim = 0
      j.each_with_index do |active, index|
        if active == 1
          if p[index][0][0] > max_sim
            k_1 = index
            max_sim = p[index][0][0]
          end
        end
      end
      k_2 = p[k_1][0][1]

      # Record the merge
      a.push([k_1, k_2])
      j[k_2] = 0
      clusters[k_1].concat(clusters[k_2])
      clusters[k_2] = nil

      # Recalculate similarities as needed
      p[k_1] = []

      new_length = clusters[k_1].length
      new_sum = Array.new(tfidf[0].length, 0)
      clusters[k_1].each do |note|
        tfidf[note].each_with_index do |ele, index|
          new_sum[index] += ele
        end
      end

      j.each_with_index do |active, index|
        if active == 1 && index != k_1
          p[index].delete_if {|item| item[1] == k_1 || item[1] == k_2 }

          comp_length = clusters[index].length
          comp_sum = Array.new(tfidf[0].length, 0)
          clusters[index].each_with_index do |ele, index|
            comp_sum[index] += ele
          end

          sum_length = new_length + comp_length
          sum_vectors = Array.new(tfidf[0].length, 0)
          new_sum.each_with_index do |ele, index|
            sum_vectors[index] += ele + comp_sum[index]
          end

          new_c = (1/(sum_length * (sum_length - 1))) * (dotproduct(sum_vectors, sum_vectors) - sum_length)

          p[k_1].push([new_c, index])
          p[index].push([new_c, k_1])
          p[index].sort! { |x,y| y[0] <=> x[0] }
        end
      end

      p[k_1].sort! { |x,y| y[0] <=> x[0] }
    end

    # Prep outputs
    clusters.compact!

    seeds = Array.new(clusters.length) { Array.new(tfidf[0].length, 0) }
    clusters.each_with_index do |cluster, index|
      cluster.each do |note|
        tfidf[note].each_with_index do |ele, e|
          seeds[index][e] += ele
        end
      end
      clen = cluster.length
      seeds[index].map! { |ele| ele/clen }
    end

    [seeds, clusters]
  end

  def dotproduct(vect1, vect2)
    size = vect1.length
    sum = 0
    i = 0
    while i < size
      sum += vect1[i] * vect2[i]
      i += 1
    end
    sum
  end

  def clusters
    # Cluster processing
    terms = self.term_list
    tfidf = self.tfidf_matrix(terms)
    # seeds, clusters = self.kmeans(tfidf)
    seeds, clusters = self.hac(tfidf)

    # Basic cluster-internal labeling
    numLabels = 7
    labelSeeds = seeds
    labels = Hash.new()
    labels = { :name => "Reflections" , :children => Array.new() }

    labelSeeds.each_with_index do |seed,index|
      labels[:children].push({ :name => index.to_s , :children => Array.new() })
      clength = clusters[index].length
      numLabels.times do |l|
        val,i = seed.each_with_index.max
        seed[i] = 0
        word = terms[i]
        labels[:children][index][:children].push({:name => word, :value => val})
      end
    end

    labels

  end
  
end
