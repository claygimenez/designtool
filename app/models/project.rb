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

    # Adjust tf values to normalize document length
    # Using augmented weighting scheme
    tfidf.map do |note|
      tf_max = note.max
      note.map! do |tf|
        tf = 0.5 + ((0.5 * tf)/tf_max)
      end
    end

    # Determine idf and multiply
    idf = Array.new(terms.length, 0)
    tfidf.map do |note|
      note.each_with_index do |tf,index|
        if tf > 0
          idf[index] += 1
        end
      end
    end

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
    k = 3

    # Stop conditions
    i_max = 10

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
    i_max.times do |i|
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
        seeds[cindex] = newseed
      end

    end

    # Return results
    [seeds,clusters]
  end

  def labeled_kmeans
    # Cluster processing
    terms = self.term_list
    tfidf = self.tfidf_matrix(terms)
    seeds, clusters = self.kmeans(tfidf)

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
