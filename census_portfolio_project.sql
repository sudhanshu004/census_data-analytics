select * from project.dbo.Data1;
select * from project.dbo.Data2;

--number of rows in dataset

select count(*) from project..Data1
select count(*) from project..Data2

--dataset for jharkhand and bihar

select * from  project..data1 where state in ('jharkhand', 'bihar')

--calculate total population

select sum(population) as population from project..Data2

--average growth of india

select avg(growth)*100 as avg_growth  from project..Data1

--average growth for each state

select state,avg(growth)*100 as avg_growth  from project..Data1
group by state;

-- avg sex ratio

select state,round(avg(Sex_Ratio),0) as avg_sex_ratio  from project..Data1 group by State order by avg_sex_ratio desc;

--avg literacy rate more than 90

select state,round(avg(Literacy),0) as avg_literacy  from project..Data1 group by State 
having round(avg(Literacy),0) >90 order by avg_literacy desc;

--average literacy rate less than 70

select state,round(avg(Literacy),00) avg_literacy  from project..Data1 
group by State
having round(avg(literacy),00)<70
order by round(avg(Literacy),00) asc;

--top 3 state showing highest growth ratio

select top 3 state, avg(Growth)*100 avg_growth from project..Data1 group by state order by avg_growth desc;

--bottom 3 state showing lowest growth ratio

select top 3 state, avg(Growth)*100 avg_growth from project..Data1 group by state order by avg_growth asc;

--top 3 states and lowest 3 states with respect to literacy rate

drop table if exists #topstates;
create table #topstates
(state_name varchar(250),
rate float)
insert into #topstates
select state,avg(literacy) from project..Data1 group by state order by avg(literacy) desc;
select top 3 * from #topstates order by #topstates.rate desc;

drop table if exists #bottomstates;
create table #bottomstates
(state_name varchar(250),
rate float)
insert into #bottomstates
select state,avg(literacy) from project..Data1 group by state order by avg(literacy) asc;
select top 3 * from #bottomstates order by #bottomstates.rate asc;

select * from (select top 3 * from #topstates order by #topstates.rate desc) a
union
select * from (select top 3 * from #bottomstates order by #bottomstates.rate asc)b;


--states starting with letter A

select  distinct state from project..Data1 where state like 'A%' or state like'B%' or state like 'G%' ;

--joining both table and finding total male and female

select d.state,sum(d.males) total_males, sum (d.females) total_females from
(select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males ,round(c.population-(c.population/(1+c.sex_ratio)),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project..Data1 a inner join project..Data2 b on a.district=b.district) c) d
group by d.state;

--total literate people and total illiterate people
select d.state,sum(literate_people) total_literate,sum(illiterate_people) total_illiterate from
(select c.district,c.state,round(c.literacy_ratio*c.population,0) literate_people,round((1-c.literacy_ratio)*c.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from project..Data1 a inner join project..Data2 b on a.district=b.district) c) d
group by d.state;


--population in previous census

select sum(e.previous_population),sum(e.population) from
(select d.state,sum(d.previous_population) previous_population,sum(d.population) population from
(select c.district,c.state,round(c.population/(1+c.growth),0) previous_population,c.Population from
(select a.district,a.state,a.growth,b.population from project..Data1 a inner join project..Data2 b on a.district=b.district) c) d
group by d.state) e





;















 