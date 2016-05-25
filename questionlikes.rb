require_relative 'questions.rb'

class QuestionLike

  def initialize(option)
    @id = options['id']
    @likes = options['likes']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      questions_likes
      JOIN
        users
      ON users.id = questions_likes.user_id
    WHERE
      question_likes.question_id = ?
    SQL
    raise "No one likes this" if likers.empty?
    likers
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(users.*)
    FROM
      questions_likes
      JOIN
        users
      ON users.id = questions_likes.user_id
    WHERE
      question_likes.question_id = ?
    GROUP BY
      users.*
    SQL
    raise "No one likes this" if likers.empty?
    num_likes
  end

  def self.liked_questions_for_user_id(user_id)
    liked = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
        JOIN question_likes
        ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL
    liked
  end

  def self.most_liked_questions(n)
    most_liked = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*, COUNT(questions.id)
    FROM
      questions
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(questions.id)
    LIMIT
      ?
    SQL
    most_liked
  end

  


end
