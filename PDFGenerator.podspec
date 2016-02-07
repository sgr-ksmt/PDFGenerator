Pod::Spec.new do |s|
  s.name             = "PDFGenerator"
  s.version          = "0.2.0"
  s.summary          = "A simple PDF generator."
  s.description      = <<-DESC
                          A simple PDF generator.
                          Generate PDF from UIView(s) or UIImage(s)
                       DESC
  s.homepage         = "https://github.com/sgr-ksmt/PDFGenerator"
  # s.screenshots     = ""
  s.license          = 'MIT'
  s.author           = { "Suguru Kishimoto" => "melodydance.k.s@gmail.com" }
  s.source           = { :git => "https://github.com/sgr-ksmt/PDFGenerator.git", :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.source_files     = "PDFGenerator/**/*"
  # s.resource_bundles = ""
  # s.public_header_files = ""
  # s.frameworks = ""
  # s.dependency ""
end
