$LOAD_PATH << '.'
require "connection"

module Model
  class Device < Connection
    attr_accessor :id, :device_type_sc, :device_name, :nick_name, :owner_type_sc, :owner_id, :unique_id, :apple_id, :apple_id_password, :apple_title, :apple_slogan, :charge_start_date, :charge_end_date, :is_active, :note, :create_user, :create_date, :last_modify_user, :last_modify_date, :is_deleted

    def save
      sql = "insert into device "
      sql << "(device_type_sc,device_name,owner_type_sc,owner_id,unique_id,apple_id,apple_id_password,apple_title,apple_slogan,charge_start_date,charge_end_date,is_active,note,create_user,create_date,last_modify_user,last_modify_date,is_deleted )"
      sql << " values "
      sql << "('#{device_type_sc}','#{device_name}',#{owner_type_sc},'#{owner_id}','#{unique_id}','#{apple_id}','#{apple_id_password}','#{apple_title}','#{apple_slogan}','#{charge_start_date}','#{charge_end_date}','#{is_active}','#{note}','#{create_user}','#{create_date}','#{last_modify_user}','#{last_modify_date}','#{is_deleted}')"
      insert(sql)
    end
  end

  class CustodianAccepters < Connection
    attr_accessor :id, :device_id, :custodian_type_sc, :custodian_id, :org_id, :create_user, :create_date
    
    def save
      sql = "insert into device_custodian"
      sql << "(device_id,custodian_type_sc,custodian_id,org_id,create_user,create_date)"
      sql << " values "
      sql << " ('#{device_id}','#{custodian_type_sc}','#{custodian_id}','#{org_id}','#{create_user}','#{create_date}')"
      insert(sql)
    end

  end
end