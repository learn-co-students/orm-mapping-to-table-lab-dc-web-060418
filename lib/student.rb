class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


  attr_accessor :name, :grade
  attr_reader :id

def initialize(name, grade)
  @name = name
  @grade = grade
end

#----creates table if it doesn't exits
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name varchar(255), grade INTEGER);
    SQL
    DB[:conn].execute(sql)
  end
#-------drops (deletes table) if it exitsts
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
      SQL
    DB[:conn].execute(sql)
  end
#---------saves student to database Students
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    sql = "SELECT last_insert_rowid()"
    @id = DB[:conn].execute(sql)[0][0]
  end
#----------creates a new student-ruby object, saves that object into the db, returns student-ruby object
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save

    student
  end


end
