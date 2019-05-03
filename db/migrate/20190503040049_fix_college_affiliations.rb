class ConvertArtsAccountsToArtsAffiliation < ActiveRecord::Migration[5.1]
  def change
    Account.all.each do |a|
    	if a.affiliation == Account::ARCH_AFFILIATION && 
    		 a.uf_college != "College of Design, Construction, and Planning"
        puts "Changing college for: #{a.first_name} #{a.last_name} - #{a.uf_college} to DCP "
        a.update(:uf_college => "College of Design, Construction, and Planning")

      elsif a.affiliation == Account::ARTS_AFFILIATION &&
       		  a.uf_college != "College of the Arts"
        puts "Changing affiliation for: #{a.first_name} #{a.last_name} - #{a.uf_college} to Arts"
        a.update(:uf_college => "College of the Arts")
      end
    end
  end
end
