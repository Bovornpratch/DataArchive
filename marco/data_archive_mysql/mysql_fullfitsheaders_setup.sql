ALTER TABLE allkeys ADD COLUMN `ra_degree` FLOAT, ADD COLUMN `dec_degree` FLOAT;

UPDATE allkeys SET `ra_degree` =
  (CONVERT(SUBSTRING_INDEX(`ra`,':',1), decimal(20,10)) +
   CONVERT(SUBSTRING_INDEX(SUBSTRING_INDEX(`ra`,':',2), ':', -1), decimal(20,10)) / 60. +
   CONVERT(SUBSTRING_INDEX(SUBSTRING_INDEX(`ra`,':',3), ':', -1), decimal(20,10)) /3600.) * 15.;

UPDATE allkeys SET `dec_degree` =
  CONVERT(SUBSTRING_INDEX(`dec`,':',1), decimal(20,10)) +
  SIGN(CONVERT(SUBSTRING_INDEX(`dec`,':',1), decimal)) * CONVERT(SUBSTRING_INDEX(SUBSTRING_INDEX(`dec`,':',2), ':', -1), decimal(20,10)) / 60. +
  SIGN(CONVERT(SUBSTRING_INDEX(`dec`,':',1), decimal)) * CONVERT(SUBSTRING_INDEX(SUBSTRING_INDEX(`dec`,':',3), ':', -1), decimal(20,10)) /3600.;    

CREATE TABLE allkeys_pos SELECT ra_degree, dec_degree FROM allkeys;

CREATE FUNCTION vincenty (lat1 DOUBLE, long1 DOUBLE, lat2 DOUBLE, long2 DOUBLE) RETURNS FLOAT
  RETURN DEGREES(
    ATAN2(
      SQRT(
         POW(COS(RADIANS(lat1))*SIN(RADIANS(IF (long1 % 360 - long2 % 360 > 180, 360 - long1 % 360 - long2 % 360, long1 % 360 - long2 % 360))), 2) +
           POW(COS(RADIANS(lat2))*SIN(RADIANS(lat1)) -
           (SIN(RADIANS(lat2))*COS(RADIANS(lat1)) *
            COS(RADIANS(IF (long1 % 360 - long2 % 360 > 180, 360 - long1 % 360 - long2 % 360, long1 % 360 - long2 % 360)))), 2)),
      SIN(RADIANS(lat2))*SIN(RADIANS(lat1)) +
        COS(RADIANS(lat2))*
        COS(RADIANS(lat1))*
        COS(RADIANS(IF (long1 % 360 - long2 % 360 > 180, 360 - long1 % 360 - long2 % 360, long1 % 360 - long2 % 360)))
    )
  );

