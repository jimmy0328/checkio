require 'mysql2'
require 'yaml'
class Connection  

  def initialize()
    data = YAML::load(File.open("setting.yml"))
    host = data['database']["host"] 
    username = data['database']["username"]
    password = data['database']["password"] 
    dbname = data['database']["dbname"] 
    @conn = Mysql2::Client.new(:host => host, :username => username,:password=>password,:database=>dbname) 
  end

  def query(sql)
    result = @conn.query(sql)
  end

  def insert(sql)
    @conn.query(sql)
    id = @conn.last_id
  end

  ## execute sql command
  def execute(sql)
    @conn.query(sql)
  end

  def close()
    @conn.close if @conn
  end

end