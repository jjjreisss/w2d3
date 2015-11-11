require_relative 'questions_database'
require_relative 'user'

class QuestionLike

  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id, @user_id, @question_id = options.values_at('id', 'user_id',
      'question_id')
  end

  def self.find_by_id(id)
    this_question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM question_likes WHERE id = ?
    SQL
    return nil if this_question_like.empty?
    QuestionLike.new(this_question_like.first)
  end

  def self.likers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        u.id, u.fname, u.lname
      FROM
        users u
      JOIN
        question_likes ql ON u.id = ql.user_id
      WHERE
        ql.question_id = ?
    SQL
    return nil if users.empty?
    users.map { |user| User.new(user) }
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.get_first_value(<<-SQL, question_id)
      SELECT
        COUNT(question_likes.user_id)
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_likes.question_id
    SQL
    return num_likes
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL
    return nil if questions.empty?
    questions.map { |question| Question.new(question) }
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        q.id, q.title, q.body, q.user_id
      FROM
        questions q
      JOIN
        question_likes ql ON q.id = ql.question_id
      GROUP BY
        q.id
      ORDER BY
        COUNT(*) DESC
      LIMIT(?)
    SQL
    return nil if questions.empty?
    questions.map { |question| Question.new(question) }
  end

  
end
