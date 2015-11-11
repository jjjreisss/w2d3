load 'question.rb'
load 'question_follow.rb'
load 'question_like.rb'
load 'questions_database.rb'
load 'reply.rb'
load 'user.rb'
# p Reply.find_by_user_id(1)
# p Reply.find_by_question_id(2)
johnny = User.find_by_id(1)
# p johnny.authored_replies
# juraj = User.find_by_id(2)
# p juraj.authored_replies
# p question = Question.find_by_id(1)
# p question.author
# p QuestionFollow.followers_for_question_id(2)
# p QuestionFollow.followed_questions_for_user_id(1)
# p QuestionFollow.followed_questions_for_user_id(2)
# p QuestionLike.likers_for_question_id(2)
# p QuestionLike.num_likes_for_question_id(1)
# p QuestionLike.liked_questions_for_user_id(2)
# p QuestionLike.liked_questions_for_user_id(1)
# p QuestionLike.most_liked_questions(3)
p johnny.average_karma
