#!/usr/bin/python3
# -*- coding=utf8 -*-

from pyzabbix import ZabbixAPI
import yaml
import sys, os.path

config_dir = os.path.dirname(sys.argv[0])
if config_dir:
    c_file = config_dir+"/"+"config.yaml"
else:
    c_file = "config.yaml"

# 获取配置信息
def get_config(conf):
    with open(conf) as f:
        config = yaml.load(f)
        return config

# get config options
config = get_config(c_file)
Monitor_DIR = config["Monitors_DIR"]
Zabbix_URL = config["Zabbix_URL"]
Zabbix_User = config["Zabbix_User"]
Zabbix_Pass = config["Zabbix_Pass"]
Zabbix_Donot_Unlink_Template = config["Zabbix_Donot_Unlink_Template"]


# 登陆zabbix平台
try:
    zapi = ZabbixAPI(Zabbix_URL)
    zapi.login(Zabbix_User, Zabbix_Pass)
except Exception as e:
    print(e)
    print('\n 登录zabbix平台出现错误')
    sys.exit()


# 检查组名是否已经存在
def check_group(group_name):
    if zapi.hostgroup.get(filter={"name":[group_name]}):
        return True
    else:
        return False

# 创建组
def create_group(group_name):
    zapi.hostgroup.create(name=group_name)

# 通过组名获取组ID
def get_groupid(group_name):
    group_date = {
        "name":[group_name]
    }
    return str(zapi.hostgroup.get(filter=group_date)[0]['groupid'])

# 添加主机
def create_host(host_data):
    if zapi.host.get(filter=host_data):
      print( "Host %s exist" % host_data["host"] )
    else:
      zapi.host.create(host_data)
      print( "Add Host: %s " % host_data["host"] )


# 通过模板名获取模板ID
def get_templateid(template_name):
    template_data = {
        "host": template_name
    }
    result = zapi.template.get(filter=template_data)
    if result:
        return result[0]['templateid']
    else:
        return result

# 获取多template id列表
def mul_template_ids(temp_list):
    temp_id_list = []
    temp_len = len(temp_list)

    for tn in range(temp_len):
        temp_id = get_templateid(temp_list[tn].strip())
        temp_id_list.append({ "templateid": temp_id })
    return temp_id_list

# 获取多group id列表
def mul_groups_id(group_list):
    group_id_list = []
    if group_list:
        group_len = len(group_list)
    else:
        return False

    for gn in range(group_len):
        each_group = group_list[gn].strip()
        if not check_group(each_group):
            print("Add HostGroup: %s" % each_group)
            create_group(each_group)
        group_id = get_groupid(each_group)
        group_id_list.append({"groupid": "%s" %(group_id)})
    return group_id_list


def main():
    hosts = []
    if len(sys.argv) > 1:
        hosts = sys.argv[1:]
    if not hosts:
        hosts = os.listdir(Monitor_DIR)

    for each_host in hosts:
        with open(Monitor_DIR + "/" + each_host) as f:
            each_config = yaml.load(f)

            ##Get config options
            each_ip = each_config["IP"]
            hostgroups = each_config["Hostgroup"]
            each_templates = each_config["Templates"]

            group_id_list = mul_groups_id(hostgroups)
            if group_id_list:
                pass
            else:
                group_id_list = []

            temp_id_list = mul_template_ids(each_templates)

            host_data = {
                "host": each_host,
                "interfaces": [{ "type": 1,
                    "main": 1,
                    "useip": 1,
                    "ip": each_ip.strip(),
                    "dns": "",
                    "port": "10050" }],
                "groups": group_id_list,
                "templates": temp_id_list
            }

            #print "添加主机: %s ,分组: %s ,模板ID: %s" % (host_name,group,template_id)
            create_host(host_data)


if __name__ == '__main__':
    main()
