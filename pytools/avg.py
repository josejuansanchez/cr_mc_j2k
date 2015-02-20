import sys

if len(sys.argv) < 2:
    print 'Usage: avg.py <input_file>'
    sys.exit(1)

#print 'Input file:', str(sys.argv[1])

try:
    with open(str(sys.argv[1]), "r") as f:
        columns = f.readline().split(" ")
        numRows = 0
        sums = [0] * len(columns)

        for i in xrange(len(columns)):
            sums[i] += float(columns[i])
        numRows += 1

        for line in f:
            # Skip empty lines
            if not line.strip():
                continue

            values = line.split(" ")            
            #print values

            for i in xrange(len(values)):
                sums[i] += float(values[i])
            numRows += 1

        #print "\nAverage"
        avg = [0] * len(columns)

        for index, summedRowValue in enumerate(sums):
            avg[index] = summedRowValue / numRows
            #print avg[index]

        #print "\nData for the report"
        print "* PSNR(cr + mc):      ", avg[2]
        print "* PSNR(mj2):          ", avg[3]
        print "* SSIM(cr + mc):      ", avg[4]
        print "* SSIM(mj2):          ", avg[5]

except IOError:
    print "IOError"
    sys.exit(1)