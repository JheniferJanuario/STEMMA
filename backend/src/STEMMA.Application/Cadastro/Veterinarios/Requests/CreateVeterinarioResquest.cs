namespace STEMMA.Application.Cadastro.DTOs.Requests;

public class CreateVeterinarioRequest
{
    public string Nome { get; set; } = string.Empty;

    public string CRMV { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string Especialidade { get; set; } = string.Empty;
}