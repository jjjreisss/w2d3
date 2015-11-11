require_relative 'questions_database'
require_relative 'question.rb'
require_relative 'question_follow'

class User

  attr_accessor :id, :fname, :lname

  def initialize(options)
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def self.find_by_id(id)
    this_user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE id = ?
    SQL
    return nil if this_user.empty?
    User.new(this_user.first)
  end

  def self.find_by_name(fname, lname)
    this_user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL
    return nil if this_user.empty?
    User.new(this_user.first)
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    karma = QuestionsDatabase.instance.get_first_value(<<-SQL)
      SELECT
        COUNT(ql.id)/CAST(COUNT(DISTINCT(q.id)) AS FLOAT)
      FROM
        questions q
      LEFT OUTER JOIN
        question_likes ql ON q.id = ql.question_id
      GROUP BY
        q.user_id
    SQL
  end

end
