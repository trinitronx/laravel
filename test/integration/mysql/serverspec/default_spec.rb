require 'spec_helper'

describe package('php') {
  it { should be_installed }
}

describe package('mysql') {
  it { should be_installed }
}

describe package('apache2') {
  it { should be_installed }
}

describe port(80) do
  it { should be_listening }
end

describe port(3306) do
  it { should be_listening }
end

describe command('mysql -N -B --user="root" --password="rootpass" --execute="SHOW databases;"') do
  it { should return_stdout /^laraveldb$/ }
end

describe file('/srv/test-app/app/config/database.php') do
  it { should be_file }
  its(:content) { should match /^\s+['"]default['"]\s+=>\s+['"]mysql['"],$/ }
  its(:content) { should match /^\s+['"]driver['"]\s+=>\s+['"]mysql['"],$/ }
  its(:content) { should match /^\s+['"]host['"]\s+=>\s+['"]localhost['"],$/ }
  its(:content) { should match /^\s+['"]database['"]\s+=>\s+['"]laraveldb['"],$/ }
  its(:content) { should match /^\s+['"]username['"]\s+=>\s+['"]root['"],$/ }
  its(:content) { should match /^\s+['"]password['"]\s+=>\s+['"]rootpass['"],$/ }
end
