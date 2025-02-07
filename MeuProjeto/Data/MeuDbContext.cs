using MeuProjeto.Models;
using Microsoft.Extensions.Configuration;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Data;

public class MeuDbContext
{
    private readonly string _connectionString;

    public MeuDbContext(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    public Cliente GetClientePorCPF(string cpf)
    {
        using (var connection = new MySqlConnection(_connectionString))
        {
            connection.Open();
            string query = "SELECT * FROM clientes WHERE CPF = @CPF";
            using (var command = new MySqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@CPF", cpf);
                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new Cliente
                        {
                            CPF = reader["CPF"].ToString(),
                            Nome = reader["Nome"].ToString(),
                            CEP = reader["CEP"].ToString(),
                            Endereco = reader["Endereco"].ToString(),
                            Produto = reader["Produto"].ToString(),
                            DataCompra = reader.IsDBNull(reader.GetOrdinal("DataCompra")) ? null : reader.GetDateTime(reader.GetOrdinal("DataCompra"))

                        };
                    }
                }
            }
        }
        return null;
    }
}
