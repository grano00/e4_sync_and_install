import socket
from e4_utility import get_device_id, get_syncro
from multiprocessing import Pool
import code,time, datetime
import sys

which_exp = "start_exp1_"
#which_exp = "end_exp1_"

if __name__ == '__main__':

    device_id = get_device_id()
    p = Pool()
    data = p.map(get_syncro, device_id)


    timestamp = time.time()
    value = datetime.datetime.fromtimestamp(timestamp)
    mytime = value.strftime('%Y-%m-%d_%H-%M-%S')

    filename = which_exp + mytime

    with open(filename, "w") as f:
        for line in data:
            f.write("%s" % line)


#   code.interact(local=locals())
