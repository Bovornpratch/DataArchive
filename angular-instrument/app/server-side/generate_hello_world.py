import time
import sys

folder_path = sys.argv[1]

time_stamp = time.strftime('%X %x %Z')

text_file = open(folder_path + "helloworld.txt", 'w+')
text_file.write("This file was created at " + str(time_stamp))
text_file.close()

print("hello_world_" + str(int(time.time())) + ".txt")
sys.stdout.flush()
