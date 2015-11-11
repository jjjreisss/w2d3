require_relative 'questions_database'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follow'

class Question

  attr_accessor :id, :title, :body, :user_id

  def initialize(options)
    @id, @title, @body, @user_id = options.values_at('id', 'title',
      'body', 'user_id')
  end

  def self.get_all
    all_questions = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT * FROM questions
    SQL
    all_questions.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    this_question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ?
    SQL
    return nil if this_question.empty?
    Question.new(this_question.first)
  end

  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT * FROM questions WHERE user_id = ?
    SQL
    return nil if questions.empty?
    questions.map { |question| Question.new(question) }
  end

  def author
    User.find_by_id(user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
end
