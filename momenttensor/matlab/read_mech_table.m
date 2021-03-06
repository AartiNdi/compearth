function [otime,lat,lon,dep,M,eid] = read_mech_table(filename)
%READ_MECH_TABLE read moment tensor table generated by write_mech_table.m
%
% INPUT
%   filename    filename (printed from write_mech_table.m)
%
% OUTPUT
%   otime       n x 1 origin time (Matlab format)
%   lat         n x 1 latitude
%   lon         n x 1 longitude
%   dep         n x 1 depth, in km
%   M           6 x n array of moment tensors in GCMT convention (up-south-east)
%                   M = [Mrr Mtt Mpp Mrt Mrp Mtp], units N-m
%   eid         n x 1 event IDs (may be empty)
%
% If you want to calculate strike, dip, rake, M0, Mw, see CMT2TT.m
%
% Carl Tape, 7/16/2015
%

NHEADER = 22;
fid = fopen(filename);
C = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s','headerlines',NHEADER);
fclose(fid);
otime = datenum(C{1},C{2},C{3},C{4},C{5},C{6});
% check: datestr(otime,'yyyy-mm-dd HH:MM:SS.FFF')
lon = C{7};
lat = C{8};
dep = C{9};
% the Mij values are listed with the highest precision
% (this is why we return M but not strike, dip, rake, M0, Mw)
M = [C{10} C{11} C{12} C{13} C{14} C{15}]';
eid = C{23};

%==========================================================================
% EXAMPLES (these will only work with GEOTOOLS at UAF)

if 0==1
    % Vipul catalog for Tape2015 paper
    idir = [getenv('GEOTOOLS') 'shared/carltape/mfsz/data/'];
    [otime,lat,lon,dep,M,eid] = read_mech_table('GCMT_mffz_mech.txt');
    [gamma,delta,M0,kappa,theta,sigma,K,N,S,thetadc,lam,U] = CMT2TT(M);
    
    % Vipul catalog for Silwal2016 paper
    idir = [getenv('GEOTOOLS') '/shared/vipul/papers/2014mt/data/'];
    [otime,elat,elon,dep,M,eid] = read_mech_table([idir 'SCAK_mech.txt']);
    Mw = CMT2mw(M);
    display_eq_summary(otime,elon,elat,dep,Mw);
    
    % Celso catalog for Alvizuri2016 paper
    idir = [getenv('GEOTOOLS') '/shared/alvizuri/papers/2014fmt/data/'];
    [otime,elat,elon,dep,M,eid] = read_mech_table([idir 'uturuncu_mech.txt']);
    Mw = CMT2mw(M);
    display_eq_summary(otime,elon,elat,dep,Mw);
end

%==========================================================================
