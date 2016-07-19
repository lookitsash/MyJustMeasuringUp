using Foundation;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MyJustMeasuringUp
{
    public class Access : SmartSql
    {
        public Access()
            : base(ConfigAdapter.GetAppSetting("Sql_ConnectionString"))
        {

        }

        public DataTable GetDIYPosts()
        {
            return GetTable("EXEC justmeasuringup..STP_DIYPostGetAll");
        }

        public void DIYApprove(string id)
        {
            using (SqlCommand cmd = new SqlCommand() { CommandType = CommandType.StoredProcedure, CommandText = "justmeasuringup..STP_DIYApprove" })
            {
                cmd.Parameters.AddWithValue("ID", id);
                ExecuteNonQuery(cmd);
            }
        }

        public void DIYDelete(string id)
        {
            using (SqlCommand cmd = new SqlCommand() { CommandType = CommandType.StoredProcedure, CommandText = "justmeasuringup..STP_DIYDelete" })
            {
                cmd.Parameters.AddWithValue("ID", id);
                ExecuteNonQuery(cmd);
            }
        }

        public void DIYPost(DIYPost post, string ipAddress)
        {
            using (SqlCommand cmd = new SqlCommand() { CommandType = CommandType.StoredProcedure, CommandText = "justmeasuringup..STP_DIYPost" })
            {
                cmd.Parameters.AddWithValue("ID", post.GUID);
                cmd.Parameters.AddWithValue("Name", post.Name);
                cmd.Parameters.AddWithValue("Desc", post.Desc);
                cmd.Parameters.AddWithValue("From", post.From);
                cmd.Parameters.AddWithValue("SiteURL", post.SiteURL);
                cmd.Parameters.AddWithValue("IPAddress", ipAddress);
                ExecuteNonQuery(cmd);
            }
        }
    }
}