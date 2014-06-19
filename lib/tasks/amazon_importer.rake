desc 'Import reviews for an amazon product'
task :import_reviews, [:asin] => [:environment] do |t, args|
  AmazonImporter.importreviews(args[:asin])
end
