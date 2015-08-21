$LOAD_PATH << '.'
require "connection"

class Login < Connection

  def run
    insert("insert into heap_log(content,timestamp)values('test1','2015-06-12 00:00:00')")
  end

  def in
    insert("insert into heap_log(content,timestamp)values('test1','2015-06-12 00:00:00')")
  end

  def out
    insert("insert into heap_log(content,timestamp)values('test1','2015-06-12 00:00:00')")
  end

  def list
    results = query("SELECT * from heap_log")
    results.each do |row|
      puts row
    end
  end
end

login = Login.new
login.list
