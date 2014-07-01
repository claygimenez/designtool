class Project < ActiveRecord::Base
  belongs_to :user
  has_many :notes

  def self.recent
    order('created_at DESC')
  end

  def reflect
    frequencies = Hash.new(0)
    self.notes.each do |note|
      notewords = note.text.split(" ")
      notewords.each do |noteword|
        unless !!(noteword =~ /\b(is|it|for|this|that|with|in|have|was|the|and|i|on|are|of|my|but|can|you|a|from|to|as|not|be|like|very|had|one|so|or|has|really|many|just|all|would|if|than|more|at|no|because)\b/i)
          frequencies[noteword] += 1
        end
      end
    end

    frequencies = frequencies.sort_by {|k,v| v}
    frequencies.reverse!

    reflections = []
    unless frequencies.blank?
      10.times do |w|
        word = frequencies[w][0]
        value = frequencies[w][1]
        reflections.push({:word => word, :value => value})
      end
    end

    reflections

    # Spoof Data
    # # [ {:word => "lets", :value => 10},
    #   {:word => "see", :value => 7},
    #   {:word => "if", :value => 3},
    #   {:word => "this", :value => 14},
    #   {:word => "works", :value => 1} ]
  end
end
