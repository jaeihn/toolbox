CREATE OR REPLACE FUNCTION timestamp_latest_transition(
  _this timestamptz, _next timestamptz, OUT _latest timestamptz)
LANGUAGE plpgsql AS
$func$
BEGIN
	if _next is null then
		_latest = _this;
	elseif GREATEST(_this, _next) = _this then
		_latest = _this;
	elseif GREATEST(_this, _next) = _next then
		_latest = _next;
	end if;
END
$func$;

CREATE OR REPLACE AGGREGATE latest_timestamp(timestamptz) (
    SFUNC = timestamp_latest_transition,
    STYPE = TIMESTAMPTZ
)
;

CREATE OR REPLACE FUNCTION timestamp_earliest_transition(
  _this timestamptz, _next timestamptz, OUT _earliest timestamptz)
LANGUAGE plpgsql AS
$func$
BEGIN
	if _next is null then
		_ = _this;
	elseif LEAST(_this, _next) = _this then
		_earliest = _this;
	elseif LEAST(_this, _next) = _next then
		_earliest = _next;
	end if;
END
$func$;

CREATE OR REPLACE AGGREGATE earliest_timestamp(timestamptz) (
    SFUNC = timestamp_earliest_transition,
    STYPE = TIMESTAMPTZ
)
;
