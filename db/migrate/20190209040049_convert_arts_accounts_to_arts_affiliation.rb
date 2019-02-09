class ConvertArtsAccountsToArtsAffiliation < ActiveRecord::Migration[5.1]
  def change
    Account.all.each do |a|
      if a.uf_college == "College of the Arts"
        puts "Changing affiliation for: #{a.first_name} #{a.last_name} - #{a.uf_college} "
        a.update(:affiliation => Account::ARTS_AFFILIATION)
      end
    end
  end
end
