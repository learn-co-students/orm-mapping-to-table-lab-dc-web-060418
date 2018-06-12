class Student
  attr_accessor :name, :grade
  attr_reader :id 
  def initialize (name, grade, id = nil)
    @name, @grade, @id = name, grade, id 
  end

  def self.create_table 
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
  end 

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql,self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create (student_hash)
    student = Student.new(student_hash[:name], student_hash[:grade])
    student.save
    student
  end

end
