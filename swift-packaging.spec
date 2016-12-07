Name:       swift-packaging
Version:    0.1
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
install -Dm0755 swift.prov %{buildroot}%{_rpmconfigdir}/swift.prov
install -Dm0755 swift.req %{buildroot}%{_rpmconfigdir}/swift.req


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
%{_sysconfdir}/rpm/macros.swift
%{_rpmconfigdir}/swift.prov
%{_rpmconfigdir}/swift.req


%changelog
* Wed Dec 7 2016 - Aleksey Mashanov <a.mashanov@corp.mail.ru> - 0.1-1
- initial revision
