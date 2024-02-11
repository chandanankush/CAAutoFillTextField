#
# Be sure to run `pod lib lint CAAutoFillTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CAAutoFillTextField'
  s.version          = '0.1.1'
  s.summary          = 'iOS plugin to show dropdown'
  s.module_name      = 'CAAutoFillTextField'
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
#  s.description      = <<-DESC
#  TODO: Add long description of the pod here.
#  DESC
  
  s.homepage         = 'https://github.com/chandanankush/CAAutoFillTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chandanankush' => 'chandan.ankush@gmail.com' }
  s.source           = { :git => 'https://github.com/chandanankush/CAAutoFillTextField.git', :branch => 'master' }
  s.swift_version    = '5.0'
  s.ios.deployment_target = '15.0'
  
  s.source_files = 'CAAutoFillTextField/Classes/**/*'
  #  s.resource_bundles = {
  #     'CAAutoFillTextField' => ['CAAutoFillTextField/Assets/*.png']
  #  }
  
end
