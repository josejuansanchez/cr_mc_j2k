import sys

DEBUG = False

def create_header():
    print "set terminal png"
    print "set output \"{0}.png\"".format(graph_type)
    print "set title ''"
    print "set xlabel 'Frame Number'"
    print "set ylabel 'PSNR [dB]'"
    print "set key out right"

def create_body():
    print "plot \"paste_{0}.txt\" using 1:{1} with lines title 'cr + mc ({0} Bytes)' axes x1y1, \\".format(start, columns[graph_type][0])

    for i in range(start + inc, end + inc, inc):
        print "     \"paste_{0}.txt\" using 1:{1} with lines title 'cr + mc ({0} Bytes)' axes x1y1, \\".format(i, columns[graph_type][0])

    ls = 1
    for i in range(start, end, inc):
        print "     \"paste_{0}.txt\" using 1:{1} with linespoints ls {2} title 'mj2 ({0} Bytes)' axes x1y1, \\".format(i, columns[graph_type][1], ls)
        ls += 1

    print "     \"paste_{0}.txt\" using 1:{1} with linespoints ls {2} title 'mj2 ({0} Bytes)' axes x1y1".format(end, columns[graph_type][1], ls)

if len(sys.argv) < 5:
    print 'Usage: create_gnuplot_file.py <start-bitrate> <end-bitrate> <increment> <psnr | ssim | bytes>'
    sys.exit(1)

if __name__ == '__main__':
    start = int(sys.argv[1])
    end = int(sys.argv[2])
    inc = int(sys.argv[3])
    graph_type = str(sys.argv[4])
    columns = { "bytes": [1, 2], "psnr": [3,4], "ssim": [5, 6] }

    create_header()
    create_body()

    if DEBUG:
        print "* start:      ", start
        print "* end:        ", end
        print "* inc:        ", inc
        print "* graph type: ", graph_type
        print "* columns:    ", columns[graph_type]