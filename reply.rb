require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class Reply

  attr_accessor :id, :body, :subject_question, :parent_reply, :user_id

  def initialize(options)
    @id, @body, @subject_question, @parent_reply, @user_id =
      options.values_at('id', 'body', 'subject_question', 'parent_reply', 'user_id')
  end

  def self.find_by_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE id = ?
    SQL
    return nil if replies.empty?
    Reply.new(replies.first)
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT * FROM replies WHERE user_id = ?
    SQL
    return nil if replies.empty?
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT * FROM replies WHERE subject_question = ?
    SQL
    return nil if replies.empty?
    replies.map { |reply| Reply.new(reply) }
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(subject_question)
  end

  def parent_reply
    Reply.find_by_id(parent_reply)
  end

  def child_reply
    child_replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE parent_reply = ?
    SQL
    return nil if child_replies.empty?
    child_replies.map { |child| Reply.new(child) }
  end
end
