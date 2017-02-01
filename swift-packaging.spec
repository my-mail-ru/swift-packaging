Name:       swift-packaging
Version:    0.6
Release:    1%{?dist}
Summary:    RPM Macros and Utilities for Swift Packaging
BuildArch:  noarch

Group:      Development/Tools
License:    MIT
URL:        https://github.com/my-mail-ru/%{name}
Source0:    https://github.com/my-mail-ru/%{name}/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz
BuildRoot:  %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

Requires:   swift
Requires:   perl
Requires:   perl-JSON-XS

%description
This package contains RPM macros and other utilities useful for packaging
Swift modules and applications in RPM-based distributions.


%prep
%setup -q


%build


%install
rm -rf %{buildroot}
install -Dm0644 macros.swift %{buildroot}%{_sysconfdir}/rpm/macros.swift
install -Dm0755 find-swift-modules %{buildroot}%{_rpmconfigdir}/find-swift-modules
install -Dm0755 swift.prov %{buildroot}%{_rpmconfigdir}/swift.prov
install -Dm0755 swift.req %{buildroot}%{_rpmconfigdir}/swift.req
install -Dm0755 swift-rpm %{buildroot}%{_bindir}/swift-rpm


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
%{_sysconfdir}/rpm/macros.swift
%{_rpmconfigdir}/find-swift-modules
%{_rpmconfigdir}/swift.prov
%{_rpmconfigdir}/swift.req
%{_bindir}/swift-rpm


%changelog
* Wed Feb 1 2017 - Aleksey Mashanov <a.mashanov@corp.mail.ru> - 0.6-1
- swiftpm() is about modules only not libraries
* Tue Jan 31 2017 - Aleksey Mashanov <a.mashanov@corp.mail.ru> - 0.5-1
- swift-rpm
* Mon Jan 30 2017 - Aleksey Mashanov <a.mashanov@corp.mail.ru> - 0.4-1
- support running find-requires more then once
- do not add to default dylib modules which have their own dylibs
* Mon Dec 12 2016 - Aleksey Mashanov <a.mashanov@corp.mail.ru> - 0.3-1
- generating less trash when building swiftperl
* Thu Dec 8 2016 - Aleksey Mashanov <a.mashanov@corp.mail.ru> - 0.2-1
- better handling of various sources layout
* Wed Dec 7 2016 - Aleksey Mashanov <a.mashanov@corp.mail.ru> - 0.1-1
- initial revision
