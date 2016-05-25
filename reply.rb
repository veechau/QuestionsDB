
class Reply
  attr_accessor :body, :asker_id, :parent_id, :question_id

  def initialize(options)
     @id = options['id']
     @body = options['body']
     @asker_id = options['asker_id']
     @parent_id = options['parent_id']
     @question_id = options['question_id']
  end

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map {|datum| Reply.new(datum)}
  end


  def save
    if @id
      raise "#{self} not in database" unless @id
      QuestionsDatabase.instance.execute(<<-SQL, @body, @asker_id, @parent_id, @question_id, @id)
        UPDATE
          users
        SET
          body = ?, asker_id = ?, parent_id = ?, question_id = ?
        WHERE
          id = ?
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, @body, @asker_id, @parent_id, @question_id)
      INSERT INTO
        users (body, asker_id, parent_id, question_id)
      VALUES
        (?, ?, ?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

  def self.find_by_user_id(asker_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, asker_id)
      SELECT
        *
      FROM
        replies
      WHERE
        asker_id = ?
      SQL
    raise "#{self} not in database" if reply.empty?
    reply

  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
      SQL
      raise "#{self} not in database" if reply.empty?
      reply
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def author
    asker_id
  end

  def question
    question_id
  end

  def parent_reply
    parent_id
  end

  def child_replies
    child = QuestionsDatabase.instance.execute(<<-SQL, asker_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = asker_id
    SQL
    raise "no children for this reply" if child.empty?

    child
  end
end
