
class QuestionFollow
  attr_accessor :user_id, :question_id

  def initialize(input)
    @user_id = input['user_id']
    @question_id = input['question_id']
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
        JOIN
          users
        ON
          users.id = question_follows.user_id
      WHERE
        question_id = ?
      SQL
    raise "No followers" if followers.empty?
    followers.map {|datum| User.new(datum)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_follows
        JOIN
          questions
        ON
        questions.id = question_follows.question_id
      WHERE
      user_id = ?
    SQL
    raise "No questions followed" if questions.empty?
    questions.map {|datum| Question.new(datum)}
  end

  def self.most_followed_questions(n)
    most_followed = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*, COUNT(*)
      FROM
        question_follows
        JOIN questions
        ON questions.id = question_follows.question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        5
    SQL
    raise "No followed questions" if most_followed.empty?
    most_followed
  end

end
