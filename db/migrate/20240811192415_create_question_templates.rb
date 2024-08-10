# frozen_string_literal: true

class CreateQuestionTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :question_templates do |t|
      t.string :question_text, null: false
      t.string :correct_answer, null: false
      t.string :incorrect_answer, null: false

      t.timestamps
    end
  end
end
