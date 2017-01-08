puts "Menards"
puts "-------"
puts "total: #{Listing.where.not(menards_url:nil).count}"

puts "==="
puts "Home Depot"
puts "-------"
puts "total: #{Listing.where.not(hd_url:nil).count}"

puts "==="
puts "houzz"
puts "-------"
puts "total: #{Listing.where.not(houzz_url:nil).count}"

puts "-=-=-=-="
puts "HD > Menards overlaps: #{ Listing.all.select { |l| l.vendors[:hd].present? && l.vendors[:menards].present? }.count}"
puts "HD > Houzz overlaps: #{ Listing.all.select { |l| l.vendors[:hd].present? && l.vendors[:houzz].present? }.count}"
puts "Menards > Houzz overlaps: #{ Listing.all.select { |l| l.vendors[:houzz].present? && l.vendors[:menards].present? }.count}"

puts '-=--=-=-'
puts "total Menards with url only: #{Listing.all.select { |l| l.vendors[:menards].nil? && l.menards_url.present? }.count }"


