require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'when validates' do
    it 'checks presence of name' do
      expect(Task.create.errors[:name]).not_to be_empty
    end
  end
end
