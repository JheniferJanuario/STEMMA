using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Response;

namespace STEMMA.Application.Cadastro.Veterinarios.Services;

public interface IVeterinarioService
{
    Task<Guid> CriarAsync(CreateVeterinarioRequest request);

    Task<VeterinarioResponse> ObterPorIdAsync(Guid id);

    Task<List<VeterinarioResponse>> ListarAsync();

    Task<VeterinarioResponse> AtualizarAsync(
        Guid id,
        UpdateVeterinarioRequest request);

    Task RemoverAsync(Guid id);
}