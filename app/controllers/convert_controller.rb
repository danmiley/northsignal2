class ConvertController < ApplicationController
  require 'csv'

  def index
    
      @input_file = params[:input].chomp
      @output_file = params[:output].chomp
      record_name = "my lil record"
      
      # write an xml
      csv = CSV::parse(File.open(File.join(RAILS_ROOT, 'public', @input_file)) {|f| f.read} )
      fields = csv.shift

      File.open(File.join(RAILS_ROOT, 'public', @output_file), 'w') do |f|
        f.puts '<?xml version="1.0"?>'
        f.puts '<records>'
        csv.each do |record|
          f.puts " <#{record_name}>"
          for i in 0..(fields.length - 1)
            f.puts "  <#{fields[i]}>#{record[i]}</#{fields[i]}>"
          end
          f.puts " </#{record_name}>"
        end
        f.puts '</records>'
      end # End file block - close file
      
      #write an yaml
      csv = CSV::parse(File.open(File.join(RAILS_ROOT, 'public', @input_file)) {|f| f.read} )
      fields = csv.shift

      File.open(File.join(RAILS_ROOT, 'public', @output_file + ".yml"), 'w') do |f|
        f.puts '# !happy yaml fixture file'
         count = 0
        csv.each do |record|
          count = count + 1
          f.puts "#{count.to_s}:" # global name line

          
          for i in 0..(fields.length - 1)
            f.puts "  #{fields[i]}: #{clean_up(record[i])}"
            if fields[i] == 'candidate'
                       f.puts "  candidate_label: #{record[i]}"  #what will be returned
                     end
          end
          # bonus lines
          # application
          f.puts "  app: ps"
          f.puts "  priority: 1"
                    
          f.puts " "
        end
      end # End file block - close file
      

      puts "Contents of #{@input_file} written as XML to #{@output_file}."
      

      render
  end
  
  def clean_up(str)
    # normalize case, chomp, and singularize
    result = ''
    
      result = str.split.map{ |x| x.chomp.downcase.pluralize.singularize + " " }.to_s.strip #intended to work for multi tokens
    
    #  result = str
    
    result
  end
end
