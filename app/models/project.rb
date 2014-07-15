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
end
