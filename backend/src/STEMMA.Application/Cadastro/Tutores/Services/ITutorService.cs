using STEMMA.Application.Cadastro.DTOs.Requests;

using STEMMA.Application.Cadastro.DTOs.Responses;

namespace STEMMA.Application.Cadastro.Tutores.Services;

public interface ITutorService
{
    Task<Guid> CriarAsync(CreateTutorRequest request);

    Task<TutorResponse> ObterPorIdAsync(Guid id);

    Task<List<TutorResponse>> ListarAsync();

    Task<TutorResponse> AtualizarAsync(
        Guid id,
        UpdateTutorRequest request);

    Task RemoverAsync(Guid id);
}