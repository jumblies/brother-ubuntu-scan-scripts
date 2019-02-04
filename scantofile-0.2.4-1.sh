#! /bin/sh
#
#   $1 = scanner device
#   $2 = friendly name
#    100,200,300,400,600
# 200 is a little more than half the size but still readable.
resolution=200
device=$1
#device='brother4:net1;dev0'
#BASE= /home/glamke/brscan
sleep  0.01
output_tmp=/home/glamke/brscan/"`date +%Y%m%d_%H%M%S`"
echo "scan from $2($device)"
# Parameters on blog here 
scanadf --device-name 'brother4:net1;dev0' --resolution $resolution -o"$output_tmp"_%04d
# hanging with below param
#scanadf --mode '24bit Color[Fast]' --resolution 300 -y 270 -o "$output_tmp"_%04d".pnm"
for pnmfile in $(ls "$output_tmp"*)
do
   echo pnmtops "$pnmfile"  "$pnmfile".ps
#   pnmtops -imagewidth=8.5 -width=8.5 "$pnmfile"  > "$pnmfile".ps
    pnmtops  "$pnmfile"  > "$pnmfile".ps  
   rm -f "$pnmfile"
done
echo psmerge -o"$output_tmp".ps  $(ls "$output_tmp"*.ps)
psmerge -o"$output_tmp".ps  $(ls "$output_tmp"*.ps)

echo "Converting ""$output_tmp".ps "$output_tmp"_CLR.pdf
ps2pdf  "$output_tmp".ps   "$output_tmp"_CLR.pdf
# Convert same PS to greyscale and then to pdf
gs \
   -sDEVICE=pdfwrite \
   -sProcessColorModel=DeviceGray \
   -sColorConversionStrategy=Gray \
   -dOverrideICC \
   -o "$output_tmp"_GS.pdf \
   -f "$output_tmp"_CLR.pdf

# Failed options
# ps2pdf  "$output_tmp"_GS.ps   "$output_tmp"_GS.pdf
# ps2pdf -dUseFlateCompression=true does nothing since it is a scanned image
# pdfcrop  "$output_tmp".pdf "$output_tmp"_crop.pdf #not needed after adjusting adf size above
#cleanup
for psfile in $(ls "$output_tmp"*.ps)
do
   rm $psfile
done
rm -f "$pnmfile".ps
/opt/brother/scanner/brscan-skey/brscan-skey
