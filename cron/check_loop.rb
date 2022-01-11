

## .staus ファイルのディレクトリ
dir = ARGV[0] 

# p "---- dir ---"
sdir = dir + "/*.status"
# p sdir

### main loop
status_list = Dir.glob(sdir)
status_list.each  do |each_file|
    status_number = 0
    p "----------" + each_file + "------------"
    File.open(each_file, "r") do |f|
        status_number = f.read.to_i
    end
    case status_number
        when 1
            p "いちがでました"
        when 2
            p "２がでました"
        else
            p "それ以外でした"
            p status_number
        end
end
