require_relative 'questions_database'
require_relative 'user'
require_relative 'question'

class QuestionFollow

  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id, @user_id, @question_id = options.values_at('id', 'user_id',
      'question_id')
  end

  def self.find_by_id(id)
    this_question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM question_follows WHERE id = ?
    SQL
    return nil if this_question_follow.empty?
    QuestionFollow.new(this_question_follow.first)
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN
        question_follows ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL
    return nil if followers.empty?
    followers.map { |follower| User.new(follower) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL
    return nil if questions.empty?
    questions.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        q.id, q.title, q.body, q.user_id
      FROM
        questions q
      JOIN
        question_follows f ON q.id = f.question_id
      GROUP BY
        q.id
      ORDER BY
        COUNT(f.id) DESC
      LIMIT(?)
    SQL
    return nil if questions.empty?
    questions.map { |question| Question.new(question) }
  end

  

end
