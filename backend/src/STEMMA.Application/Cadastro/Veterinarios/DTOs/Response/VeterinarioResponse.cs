namespace STEMMA.Application.Cadastro.Veterinarios.DTOs.Response;

public class VeterinarioResponse
{
    public Guid Id { get; set; }

    public string Nome { get; set; } = string.Empty;

    public string CRMV { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string Especialidade { get; set; } = string.Empty;

    public DateTime DataCriacao { get; set; }
}