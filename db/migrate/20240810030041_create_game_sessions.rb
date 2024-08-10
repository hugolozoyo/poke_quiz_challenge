# frozen_string_literal: true

class CreateGameSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :game_sessions do |t|
      t.string :username, null: false, limit: 50, index: { unique: true }
      t.integer :score, null: false, default: 0
      t.datetime :finished_at, null: true, default: nil
      t.integer :retry_count, null: false, default: 1

      t.timestamps
    end
  end
end
