import select, socket, time
import code
#code.interact(local=locals())


server = '127.0.0.1'
port = 28000
buffer_size = 1024
how_many = 2 #define how many tag acquire


# This function return the list of connected wristbands
def get_device_id():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((server, port))
    list_devices = "device_list\r\n"
    s.send(list_devices.encode())

    ready = select.select([s], [], [], 10)
    if ready[0]:
        data = s.recv(4096).decode("utf-8")

    data = data.split('|')
    del data[0]

    print('find '+ str(len(data)) +' devices: ')
    for i in range(len(data)):
        d = data[i].split(' ')
        data[i] = d[1]
        print(data[i])

    s.close()
    return data


# This function sent the message, if display is true it print the message and the server answer
def send_message(s,m,dev,display):
    m = m + '\r\n'
    s.send(m.encode())
    data = "err"
    ready = select.select([s], [], [], 10)
    if ready[0]:
        data = s.recv(4096).decode("utf-8")
    else:
        print(dev+': no answer')

    if display:
        print(dev+':'+m+'\n'+data)
    return data



#This function collect the timestamp acquired by the devices
def get_syncro(dev):

    server = '127.0.0.1'
    port = 28000
    message  = ""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((server, port))
#    code.interact(local=locals())
    send_message(sock, 'device_connect '+dev, dev, False)
    send_message(sock, 'device_subscribe tag ON',dev, False)

    my_time = ''
    e4_time = ''
    exit_loop = False
    h = 1
    while not exit_loop:
        print("press button on " + dev)

        ready = select.select([sock], [], [], 30)
        if ready[0]:
            data = sock.recv(4096).decode("utf-8")
            if 'E4_Tag' in data:
                print(dev + ' pressed')
                e4_time = data.split(' ')[1]
                my_time = str(time.time())
                message = message + dev + ',' + e4_time + ',' + my_time + '\n'

                if h < how_many:
                    h = h + 1
                else:
                    exit_loop = True

    #Switch off the device
    send_message(sock, 'device_disconnect_btle ' +dev,dev, True)
    #Only disconnect the device
#   send_message(sock, 'device_disconnect_btle ' + dev, dev, True)
    message = message.replace(',','.')
    sock.close()
    return message