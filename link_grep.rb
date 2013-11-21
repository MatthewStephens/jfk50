#!/usr/bin/env ruby

# find anchors in csv file and replace with short URLs
require 'csv'

hash = {
"CSA146PES11/22" => "http://bit.ly/1bG7Y47",
"HR1238PCS" => "http://bit.ly/1bG83EL",
"HR1240PCS11/22p" => "http://bit.ly/17vkGEO",
"HR1240PCS11/22" => "http://bit.ly/1fZlGU0",
"HR1243PCS11/22" => "http://bit.ly/1fnFgvx",
"HR&FK1250P11/22CST" => "http://bit.ly/18byWFz",
"FK1P11/22CST" => "http://bit.ly/1iyEThp",
"SR105PCS11/22" => "http://bit.ly/17vl4Dh",
"FK106P11/22CST" => "http://bit.ly/1fZlZhr",
"FK107P11/22CST" => "http://bit.ly/17vlidx",
"FK108P11/22CS" => "http://bit.ly/19Lwfo3",
"FK111P11/22CST" => "http://bit.ly/1c757Tq",
"FK112P11/22CST" => "http://bit.ly/1aJQKFi",
"FK113P11/22CST" => "http://bit.ly/1ekzMig",
"FK115P11/22CST" => "http://bit.ly/1h5zxLq",
"FK117P11/22CST" => "http://bit.ly/19Lwyzj",
"FK118P11/22CST" => "http://bit.ly/I7nr64",
"FK120P11/22CST" => "http://bit.ly/1fnGkj3",
"FK123P11/22CST" => "http://bit.ly/1ayKu3U",
"FK125P11/22CST" => "http://bit.ly/I2kKlE",
"FK126P11/22CST" => "http://bit.ly/17RjisY",
"FK128P11/22CST" => "http://bit.ly/1c75MEA",
"FK130P11/22CST" => "http://bit.ly/I7nGyf",
"G131PCST11/22" => "http://bit.ly/IiFxBr",
"G134PCST11/22" => "http://bit.ly/18rBnBV",
"JD135PCS" => "http://bit.ly/1c75WM9",
"A136PCD11/22" => "http://bit.ly/1baDP1L",
"A137PCD11/22" => "http://bit.ly/1ayL8yk",
"A139PCD11/22" => "http://bit.ly/17RjQPy",
"A140PCD11/22" => "http://bit.ly/17RjSqH",
"A141PCD11/22" => "http://bit.ly/1e4GfwZ",
"A147PCD11/22" => "http://bit.ly/1fnHafE",
"A148PCD11/22" => "http://bit.ly/I60NL4",
"SR150PCS11/22" => "http://bit.ly/1bG9p2m",
"A152PCD11/22" => "http://bit.ly/19LxvYb",
"A153PCD11/22" => "http://bit.ly/17vn8uY",
"A154PCD11/22" => "http://bit.ly/1bVkeRS",
"A155PCD11/22" => "http://bit.ly/1c76sd5",
"A156PCD11/22" => "http://bit.ly/1aJRSJ5",
"A158PCD11/22" => "http://bit.ly/18TGozm",
"SR159PC" => "http://bit.ly/18rBUDF",
"SR201PCS11/22" => "http://bit.ly/1i07oXz",
"SR206PCS11/22" => "http://bit.ly/1i07rTc",
"SR209PCS11/22" => "http://bit.ly/I61iou",
"SR221PCS11/22" => "http://bit.ly/18TGxmA",
"SR224PCS11/22" => "http://bit.ly/1aUc7QT",
"G230PCST11/22" => "http://bit.ly/19Ly7x2",
"CSA334PES11/22" => "http://bit.ly/I61xQn",
"CSA344PES11/22" => "http://bit.ly/17vnVfg",
"CSA345PES11/22" => "http://bit.ly/1jq8jw2",
"G247PCST" => "http://bit.ly/I2lQhl",
"G250PCST11/22" => "http://bit.ly/1bVl0OL",
"JD252PCS" => "http://bit.ly/19LymIs",
"G255PCST11/22" => "http://bit.ly/1iyHjwx",
"G259PCST11/22" => "http://bit.ly/IiGb1I",
"G301PCST11/22" => "http://bit.ly/18TH2Nk",
"G302PCST11/22" => "http://bit.ly/18bAz5Z",
"G304PCST11/22" => "http://bit.ly/1h5AWSa",
"G309PCST11/22" => "http://bit.ly/1baEFvD",
"G311PCST11/22" => "http://bit.ly/1baEGzC",
"G330PCST11/22" => "http://bit.ly/1bVlsfO",
"G331PCST11/22" => "http://bit.ly/1aJSY7F",
"G&EK343P11/22CST" => "http://bit.ly/19LyWpv",
"EK345P11/22CST" => "http://bit.ly/I7oV0c",
"EK348P11/22CST" => "http://bit.ly/1i082nS",
"EK350P11/22CST" => "http://bit.ly/1cI5zrm",
"W421PCS11/22" => "http://bit.ly/1c77WUG",
"W423PCS11/22" => "http://bit.ly/18bB3ZY",
"W424PCS11/22" => "http://bit.ly/1i08eUq",
"W426PCS11/22" => "http://bit.ly/I2mRpQ",
"W427PCS11/22" => "http://bit.ly/I2mT0N",
"W429PCS11/22" => "http://bit.ly/I2mXxy",
"W433PCS11/22" => "http://bit.ly/1fZpaWG",
"W439PCS11/22" => "http://bit.ly/1dlDY4c",
"K&FK442P11/22CST" => "http://bit.ly/1aJTwKJ",
"FK443P11/22CST" => "http://bit.ly/1fnJRhs",
"FK450P11/22CST" => "http://bit.ly/I7pvuV",
"CSA553PES11/22" => "http://bit.ly/1aJTEtC",
"CSA555PES11/22" => "http://bit.ly/1h5BKql",
"CSA556PES11/22" => "http://bit.ly/IiHa22",
"CSA6PES11/22" => "http://bit.ly/I63Ump",
"FK505P11/22CST" => "http://bit.ly/1ayPbec",
"FK506P11/22CST" => "http://bit.ly/1aJTP8a",
"FK512P11/22CST" => "http://bit.ly/I7pRSr",
"FK513P11/22CST" => "http://bit.ly/1baFh4m",
"FK515P11/22CTS" => "http://bit.ly/IiHmhD",
"FK519P11/22CST" => "http://bit.ly/I648dg",
"FK522P11/22CST" => "http://bit.ly/I7q2x5",
"FK526P11/22CTS" => "http://bit.ly/1cI5CTZ",
"FK528P11/22CTS" => "http://bit.ly/19LATT1",
"FK529P11/22CST" => "http://bit.ly/1fnKvvk"
}


quote_chars = %w(" | ~ ^ & *)

file=File.open("./TeletypeForTweeting.csv")
begin
  tweet_data = CSV.read(file, { :col_sep => "\t", :quote_char => quote_chars.shift })
rescue
  quote_chars.empty? ? raise : retry
end


tweet_data.each_with_index do |row,index| 
  next if index == 0
  if ! row[3].nil?
    str=row[3]
    key=str.gsub(/\#/, '')
puts "#{index} str: #{str.to_s} #{hash[key].to_s}"
    newstr=str.gsub(/\##{key}$/, hash[key].to_s)
    row[3]=newstr
  end
end

out="/tmp/link_grep.csv"
CSV.open(out, "wb", {:col_sep => "\t" }) do |csv|
  tweet_data.each do |row|
    csv << row
  end
end
exit 0
