class Task < ApplicationRecord
  include AASM

  belongs_to :user

  validates :name, presence: true

  aasm column: 'state' do
    state :new, initial: true
    state :started, :finished

    event :start do
      transitions from: :new, to: :started
    end

    event :finish do
      transitions from: [:new, :started], to: :finished
    end

    event :restart do
      transitions from: :finished, to: :started
    end
  end

  mount_uploader :attachment, TaskAttachmentUploader
end
