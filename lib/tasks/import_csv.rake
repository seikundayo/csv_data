#rake import_csv:users
require "csv"
namespace :import_csv do
  desc "CSVデーターをインポートするタスク"

  task users: :environment do
    path = File.join Rails.root, "db/csv_data/csv_data.csv"
    list = []
    CSV.foreach(path, headers: true) do |row|
      list << {
        name: row["name"],
        age: row["age"],
        address: row["address"]
      }
    end

    puts "インポートを開始します".red
    begin
      User.transaction do
        User.create!(list)
      end
      puts "インポート完了".green
    rescue ActiveModel::UnknownAttributeError => invalid
      puts "インポートに失敗しました#{invalid}".red
    end
  end
end
