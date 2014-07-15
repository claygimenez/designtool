class Note < ActiveRecord::Base
  belongs_to :project
  serialize :scrubbed_notes, JSON
  serialize :treat_obj, JSON

  before_save :process_note_text

  protected
    def process_note_text
      # insights = Hash.new
      scrubWords = []

      scrubNote = self.text.to_entity
      # insights['treatobj'] = scrubNote
      scrubNote.do(:chunk, :segment, :tokenize, :parse)
      self.treat_obj = scrubNote
      
      scrubNote.words.each { |word| scrubWords.push(word.to_s) }
      # insights['words'] = scrubWords

      # self.scrubbed_notes = insights
      self.scrubbed_notes = scrubWords
    end
end
