$LOAD_PATH << '.'
require "connection"
require "model"
require 'securerandom'


class TranslateDB < Connection
  include Model

  attr_accessor :devices

  def run
    clear_db
    query_device_management
    start_convert
  end

  private 

  # clear all tables
  def clear_db
    execute("delete from device_custodian")
    execute("delete from device")
  end
  
  # retrieve all device management data
  def query_device_management
    @devices = query("select * from device_management ")
  end

  # translate entry point
  def start_convert
    @devices.each do |d|
      convert_db(d)
    end
  end


  def convert_db(row)
    puts "============ #{row['device_name']} =============\n"
    puts row
    device_name = find_device_name(row)
    puts "device_name:#{device_name}"
    if last_id = check_exist_device(device_name)
      puts " check exist_device last id: #{last_id}"
      if last_id == 0
        last_id = insert_device(row,device_name)
      end
    end
    puts "last id is #{last_id}"
    insert_device_accepters(row,last_id)
  end


  def find_device_name(row)
   #  row_id   = row["role_id"]
   #  assign_id = row["assign_id"]
   #  device_name = ""
   #  puts "row_id: #{row_id} , assign_id: #{assign_id}"
   # case row_id
   #    when 1
   #      device_name << "provider"
   #    when 2
   #      sqlUserInfo = "select Abreviation as abbr from FacilityProfile where id = '#{assign_id}'"
   #      facility_name = query(sqlUserInfo)
   #      abbr = facility_name.first["abbr"]
   #      device_name << abbr
   #    when 3
   #      device_name << "staff"
   #    else
   #      device_name << "Na"
   #  end
   #  device_name << "_location_#{row["device_name"]}"
    row["device_name"]
  end

  # check 
  def check_exist_device(device_name)
    device = query("select id from device where device_name = '#{device_name}'")
    last_id = 0
    puts "select id from device where device_name = '#{device_name}'"
    if device.size > 0
      last_id = device.first["id"]
    end
    last_id
  end

  def insert_device(row,device_name)
    device = Device.new
    device.device_type_sc = row["device_type"]
    device.device_name = device_name
    device.owner_type_sc = 1
    device.owner_id = 1
    device.apple_id =row["apple_id"]
    device.apple_id_password =row["apple_id_pw"]
    device.unique_id = SecureRandom.uuid.to_s
    device.charge_start_date = row["start_charging"]
    device.charge_end_date =  row["stop_charging"]
    device.is_active = row["status"]== 1 ? "1" : "0" 
    device.note = row["note"]
    device.create_user = row["note"]
    device.create_date = row["rent_date"]!= nil ? row["rent_date"] : row["last_user_date"]
    device.last_modify_user = row["last_user_id"]
    device.last_modify_date = row["last_user_date"]
    device.is_deleted = (row["status"]== 3 ? "1" : "0")
    device.save
  end

  def insert_device_accepters(row,last_id)
    accepter = CustodianAccepters.new
    accepter.device_id = last_id
    accepter.custodian_type_sc = row["role_id"]
    accepter.custodian_id   = row["assign_id"]
    accepter.org_id  = row["group_id"]
    accepter.create_user = row["last_user_id"]
    accepter.create_date = row["last_user_date"]
    accepter.save
  end



end

db = TranslateDB.new
db.run