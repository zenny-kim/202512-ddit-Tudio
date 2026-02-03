package kr.or.ddit.common.code;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

/**
 * <pre>
 * PROJ : Tudio
 * Name : CodeEnumTypeHandler
 * DESC : CodeEnum을 구현한 모든 Enum을 처리하는 제네릭 핸들러
 * </pre>
 * 
 * @author [대덕인재개발원] team1 YHB
 * @version 1.0, 2026.01.12
 * @param <E> Enum이면서 동시에 CodeEnum을 구현한 클래스
 */
public class CodeEnumTypeHandler<E extends Enum<E> & CodeEnum> extends BaseTypeHandler<E> {
    
    private final Class<E> type;

    // MyBatis가 이 핸들러를 생성할 때, 해당 Enum 클래스 정보를 넘겨줌
    public CodeEnumTypeHandler(Class<E> type) {
        if (type == null) throw new IllegalArgumentException("Type argument cannot be null");
        this.type = type;
    }

    // 1. Java -> DB (INSERT, UPDATE 시)
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, E parameter, JdbcType jdbcType) throws SQLException {
        ps.setInt(i, parameter.getCode());
    }

    // 2. DB -> Java (SELECT 시 - 컬럼명으로 조회)
    @Override
    public E getNullableResult(ResultSet rs, String columnName) throws SQLException {
        int dbCode = rs.getInt(columnName);
        return rs.wasNull() ? null : getEnumFromCode(dbCode);
    }

    // 3. DB -> Java (SELECT 시 - 인덱스로 조회)
    @Override
    public E getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        int dbCode = rs.getInt(columnIndex);
        return rs.wasNull() ? null : getEnumFromCode(dbCode);
    }

    // 4. DB -> Java (Procedure 호출 시)
    @Override
    public E getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        int dbCode = cs.getInt(columnIndex);
        return cs.wasNull() ? null : getEnumFromCode(dbCode);
    }

    // 공통코드값을 가지고 일치하는 Enum 상수를 찾는 메서드
    private E getEnumFromCode(int dbCode) {
        E[] enumConstants = type.getEnumConstants();
        for (E constant : enumConstants) {
            if (constant.getCode() == dbCode) {
                return constant;
            }
        }
        return null; 
    }
}

