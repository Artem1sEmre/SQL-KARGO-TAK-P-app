create database kargo
go
use kargo
go

create table musteri(
musteri_id int,
ad nchar(20),
soyad nchar(20),
adres nchar(50),
tel nchar(20)
)
go

create table sube(
sube_id int,
sube_adi nchar(20),
il nchar(20)
)
go

create table kurye(
kurye_id int,
ad nchar(20),
soyad nchar(20),
tel nchar(20),
sube_id int
)
go

create table kargo(
kargo_id int,
musteri_id int,
sube_id int,
agirlik int,
ucret int,
durum nchar(20),
tarih datetime
)
go

create table teslimat(
teslimat_id int,
kargo_id int,
kurye_id int,
teslim_durumu nchar(20)
)
go

insert into musteri values (1,'Emre','Duyar','İstanbul','5551')
insert into musteri values (2,'Ali','Kaya','Ankara','5552')
go

insert into sube values (1,'Merkez','İstanbul')
insert into sube values (2,'Ankara','Ankara')
go

insert into kurye values (1,'Ahmet','Polat','5001',1)
insert into kurye values (2,'Mehmet','Ak','5002',2)
go

create trigger trg_kargo_goster
on kargo
after
insert
as
begin
select * from kargo
end
go

create trigger trg_kargo_ucret
on kargo
after
insert
as
begin
update kargo
set ucret = agirlik * 20
end
go

create trigger trg_kargo_durum
on kargo
after
insert
as
begin
update kargo
set durum = 'Hazırlanıyor'
end
go

create trigger trg_teslimat_durum
on teslimat
after
insert
as
begin
update kargo
set durum = 'Dağıtımda'
end
go

create trigger trg_kargo_silme
on kargo
instead of
delete
as
begin
print 'Kargo silinemez'
end
go

create trigger trg_kargo_update
on kargo
after
update
as
begin
select * from kargo
end
go

create trigger trg_teslimat_update
on teslimat
after
update
as
begin
select * from teslimat
end
go

create trigger trg_musteri_goster
on musteri
after
insert
as
begin
select * from musteri
end
go

create trigger trg_kurye_goster
on kurye
after
insert
as
begin
select * from kurye
end
go

create trigger trg_sube_goster
on sube
after
insert
as
begin
select * from sube
end
go

create procedure sp_musteri_ekle
@p_id int,
@p_ad nchar(20),
@p_soyad nchar(20),
@p_adres nchar(50),
@p_tel nchar(20)
as
begin
insert into musteri values (@p_id,@p_ad,@p_soyad,@p_adres,@p_tel)
end
go

create procedure sp_kargo_ekle
@p_kargo int,
@p_musteri int,
@p_sube int,
@p_agirlik int
as
begin
insert into kargo values (@p_kargo,@p_musteri,@p_sube,@p_agirlik,0,'',getdate())
end
go

create procedure sp_musteri_kargo
@p_musteri int
as
begin
select * from kargo
where musteri_id = @p_musteri
end
go

create procedure sp_en_cok_kargo
as
begin
select musteri_id, count(*) as toplam
from kargo
group by musteri_id
order by toplam desc
end
go

create procedure sp_toplam_gelir
as
begin
select sum(ucret) as toplam
from kargo
end
go

create procedure sp_sube_kargo
as
begin
select sube_id, count(*) as toplam
from kargo
group by sube_id
end
go

create procedure sp_kurye_teslim
@p_kurye int
as
begin
select * from teslimat
where kurye_id = @p_kurye
end
go

create procedure sp_gunluk_kargo
as
begin
select * from kargo
where datepart(dy,tarih) = datepart(dy,getdate())
end
go

create procedure sp_teslim_edilen
as
begin
select * from kargo
where durum='Teslim Edildi'
end
go

create procedure sp_musteri_detay
@p_musteri int
as
begin
select musteri.ad, musteri.soyad, kargo.ucret
from musteri, kargo
where musteri.musteri_id = kargo.musteri_id
and musteri.musteri_id = @p_musteri
end
go